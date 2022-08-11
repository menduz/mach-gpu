const Queue = @import("queue.zig").Queue;
const BindGroup = @import("bind_group.zig").BindGroup;
const BindGroupLayout = @import("bind_group_layout.zig").BindGroupLayout;
const Buffer = @import("buffer.zig").Buffer;
const CommandEncoder = @import("command_encoder.zig").CommandEncoder;
const ComputePipeline = @import("compute_pipeline.zig").ComputePipeline;
const ExternalTexture = @import("external_texture.zig").ExternalTexture;
const PipelineLayout = @import("pipeline_layout.zig").PipelineLayout;
const QuerySet = @import("query_set.zig").QuerySet;
const RenderBundleEncoder = @import("render_bundle_encoder.zig").RenderBundleEncoder;
const RenderPipeline = @import("render_pipeline.zig").RenderPipeline;
const Sampler = @import("sampler.zig").Sampler;
const ShaderModule = @import("shader_module.zig").ShaderModule;
const Surface = @import("surface.zig").Surface;
const SwapChain = @import("swap_chain.zig").SwapChain;
const Texture = @import("texture.zig").Texture;
const ChainedStruct = @import("types.zig").ChainedStruct;
const FeatureName = @import("types.zig").FeatureName;
const RequiredLimits = @import("types.zig").RequiredLimits;
const SupportedLimits = @import("types.zig").SupportedLimits;
const ErrorType = @import("types.zig").ErrorType;
const ErrorFilter = @import("types.zig").ErrorFilter;
const LoggingType = @import("types.zig").LoggingType;
const CreatePipelineAsyncStatus = @import("types.zig").CreatePipelineAsyncStatus;
const LoggingCallback = @import("callbacks.zig").LoggingCallback;
const ErrorCallback = @import("callbacks.zig").ErrorCallback;
const CreateComputePipelineAsyncCallback = @import("callbacks.zig").CreateComputePipelineAsyncCallback;
const CreateRenderPipelineAsyncCallback = @import("callbacks.zig").CreateRenderPipelineAsyncCallback;
const Impl = @import("interface.zig").Impl;

pub const Device = opaque {
    pub const LostCallback = fn (
        reason: LostReason,
        message: [*:0]const u8,
        userdata: ?*anyopaque,
    ) callconv(.C) void;

    pub const LostReason = enum(u32) {
        undef = 0x00000000,
        destroyed = 0x00000001,
    };

    pub const Descriptor = extern struct {
        next_in_chain: ?*const ChainedStruct = null,
        label: ?[*:0]const u8 = null,
        required_features_count: u32 = 0,
        required_features: ?[*]const FeatureName = null,
        required_limits: ?*const RequiredLimits = null,
        default_queue: Queue.Descriptor = Queue.Descriptor{},
    };

    pub inline fn createBindGroup(device: *Device, descriptor: *const BindGroup.Descriptor) *BindGroup {
        return Impl.deviceCreateBindGroup(device, descriptor);
    }

    pub inline fn createBindGroupLayout(device: *Device, descriptor: *const BindGroupLayout.Descriptor) *BindGroupLayout {
        return Impl.deviceCreateBindGroupLayout(device, descriptor);
    }

    pub inline fn createBuffer(device: *Device, descriptor: *const Buffer.Descriptor) *Buffer {
        return Impl.deviceCreateBuffer(device, descriptor);
    }

    pub inline fn createCommandEncoder(device: *Device, descriptor: ?*const CommandEncoder.Descriptor) *CommandEncoder {
        return Impl.deviceCreateCommandEncoder(device, descriptor);
    }

    pub inline fn createComputePipeline(device: *Device, descriptor: *const ComputePipeline.Descriptor) *ComputePipeline {
        return Impl.deviceCreateComputePipeline(device, descriptor);
    }

    pub inline fn createComputePipelineAsync(
        device: *Device,
        descriptor: *const ComputePipeline.Descriptor,
        context: anytype,
        comptime callback: fn (
            status: CreatePipelineAsyncStatus,
            compute_pipeline: *ComputePipeline,
            message: [*:0]const u8,
            ctx: @TypeOf(context),
        ) callconv(.Inline) void,
    ) void {
        const Context = @TypeOf(context);
        const Helper = struct {
            pub fn callback(
                status: CreatePipelineAsyncStatus,
                compute_pipeline: *ComputePipeline,
                message: [*:0]const u8,
                userdata: ?*anyopaque,
            ) callconv(.C) void {
                callback(
                    status,
                    compute_pipeline,
                    message,
                    if (Context == void) {} else @ptrCast(Context, @alignCast(@alignOf(Context), userdata)),
                );
            }
        };
        Impl.deviceCreateComputePipelineAsync(device, descriptor, Helper.callback, if (Context == void) null else context);
    }

    pub inline fn createErrorBuffer(device: *Device) *Buffer {
        return Impl.deviceCreateErrorBuffer(device);
    }

    pub inline fn createErrorExternalTexture(device: *Device) *ExternalTexture {
        return Impl.deviceCreateErrorExternalTexture(device);
    }

    pub inline fn createErrorTexture(device: *Device, descriptor: *const Texture.Descriptor) *Texture {
        return Impl.deviceCreateErrorTexture(device, descriptor);
    }

    pub inline fn createExternalTexture(device: *Device, external_texture_descriptor: *const ExternalTexture.Descriptor) *ExternalTexture {
        return Impl.deviceCreateExternalTexture(device, external_texture_descriptor);
    }

    pub inline fn createPipelineLayout(device: *Device, pipeline_layout_descriptor: *const PipelineLayout.Descriptor) *PipelineLayout {
        return Impl.deviceCreatePipelineLayout(device, pipeline_layout_descriptor);
    }

    pub inline fn createQuerySet(device: *Device, descriptor: *const QuerySet.Descriptor) *QuerySet {
        return Impl.deviceCreateQuerySet(device, descriptor);
    }

    pub inline fn createRenderBundleEncoder(device: *Device, descriptor: *const RenderBundleEncoder.Descriptor) *RenderBundleEncoder {
        return Impl.deviceCreateRenderBundleEncoder(device, descriptor);
    }

    pub inline fn createRenderPipeline(device: *Device, descriptor: *const RenderPipeline.Descriptor) *RenderPipeline {
        return Impl.deviceCreateRenderPipeline(device, descriptor);
    }

    pub inline fn createRenderPipelineAsync(
        device: *Device,
        descriptor: *const RenderPipeline.Descriptor,
        context: anytype,
        comptime callback: fn (
            status: CreatePipelineAsyncStatus,
            pipeline: *RenderPipeline,
            message: [*:0]const u8,
            ctx: @TypeOf(context),
        ) callconv(.Inline) void,
    ) void {
        const Context = @TypeOf(context);
        const Helper = struct {
            pub fn callback(
                status: CreatePipelineAsyncStatus,
                pipeline: *RenderPipeline,
                message: [*:0]const u8,
                userdata: ?*anyopaque,
            ) callconv(.C) void {
                callback(
                    status,
                    pipeline,
                    message,
                    if (Context == void) {} else @ptrCast(Context, @alignCast(@alignOf(Context), userdata)),
                );
            }
        };
        Impl.deviceCreateRenderPipelineAsync(device, descriptor, Helper.callback, if (Context == void) null else context);
    }

    pub inline fn createSampler(device: *Device, descriptor: ?*const Sampler.Descriptor) *Sampler {
        return Impl.deviceCreateSampler(device, descriptor);
    }

    pub inline fn createShaderModule(device: *Device, descriptor: *const ShaderModule.Descriptor) *ShaderModule {
        return Impl.deviceCreateShaderModule(device, descriptor);
    }

    pub inline fn createSwapChain(device: *Device, surface: ?*Surface, descriptor: *const SwapChain.Descriptor) *SwapChain {
        return Impl.deviceCreateSwapChain(device, surface, descriptor);
    }

    pub inline fn createTexture(device: *Device, descriptor: *const Texture.Descriptor) *Texture {
        return Impl.deviceCreateTexture(device, descriptor);
    }

    pub inline fn destroy(device: *Device) void {
        Impl.deviceDestroy(device);
    }

    /// Call once with null to determine the array length, and again to fetch the feature list.
    ///
    /// Consider using the enumerateFeaturesOwned helper.
    pub inline fn enumerateFeatures(device: *Device, features: [*]FeatureName) usize {
        return Impl.deviceEnumerateFeatures(device, features);
    }

    /// Enumerates the adapter features, storing the result in an allocated slice which is owned by
    /// the caller.
    pub inline fn enumerateFeaturesOwned(device: *Device, allocator: std.mem.Allocator) ![]FeatureName {
        const count = device.enumerateFeatures(null);
        var data = try allocator.alloc(FeatureName, count);
        _ = device.enumerateFeatures(data.ptr);
        return data;
    }

    pub inline fn getLimits(device: *Device, limits: *SupportedLimits) bool {
        return Impl.deviceGetLimits(device, limits);
    }

    pub inline fn getQueue(device: *Device) *Queue {
        return Impl.deviceGetQueue(device);
    }

    pub inline fn hasFeature(device: *Device, feature: FeatureName) bool {
        return Impl.deviceHasFeature(device, feature);
    }

    pub inline fn injectError(device: *Device, typ: ErrorType, message: [*:0]const u8) void {
        Impl.deviceInjectError(device, typ, message);
    }

    pub inline fn loseForTesting(device: *Device) void {
        Impl.deviceLoseForTesting(device);
    }

    pub inline fn popErrorScope(
        device: *Device,
        context: anytype,
        comptime callback: fn (typ: ErrorType, message: [*:0]const u8, ctx: @TypeOf(context)) callconv(.Inline) void,
    ) bool {
        const Context = @TypeOf(context);
        const Helper = struct {
            pub fn callback(typ: ErrorType, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void {
                callback(typ, message, if (Context == void) {} else @ptrCast(Context, @alignCast(@alignOf(Context), userdata)));
            }
        };
        return Impl.devicePopErrorScope(device, Helper.callback, if (Context == void) null else context);
    }

    pub inline fn pushErrorScope(device: *Device, filter: ErrorFilter) void {
        Impl.devicePushErrorScope(device, filter);
    }

    // TODO: presumably callback should be nullable for unsetting
    pub inline fn setDeviceLostCallback(
        device: *Device,
        context: anytype,
        comptime callback: fn (reason: LostReason, message: [*:0]const u8, ctx: @TypeOf(context)) callconv(.Inline) void,
    ) void {
        const Context = @TypeOf(context);
        const Helper = struct {
            pub fn callback(reason: LostReason, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void {
                callback(reason, message, if (Context == void) {} else @ptrCast(Context, @alignCast(@alignOf(Context), userdata)));
            }
        };
        Impl.deviceSetDeviceLostCallback(device, Helper.callback, if (Context == void) null else context);
    }

    pub inline fn setLabel(device: *Device, label: [*:0]const u8) void {
        Impl.deviceSetLabel(device, label);
    }

    // TODO: presumably callback should be nullable for unsetting
    pub inline fn setLoggingCallback(
        device: *Device,
        context: anytype,
        comptime callback: fn (typ: LoggingType, message: [*:0]const u8, ctx: @TypeOf(context)) callconv(.Inline) void,
    ) void {
        const Context = @TypeOf(context);
        const Helper = struct {
            pub fn callback(typ: LoggingType, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void {
                callback(typ, message, if (Context == void) {} else @ptrCast(Context, @alignCast(@alignOf(Context), userdata)));
            }
        };
        Impl.deviceSetLoggingCallback(device, Helper.callback, if (Context == void) null else context);
    }

    // TODO: presumably callback should be nullable for unsetting
    pub inline fn setUncapturedErrorCallback(
        device: *Device,
        context: anytype,
        comptime callback: fn (typ: ErrorType, message: [*:0]const u8, ctx: @TypeOf(context)) callconv(.Inline) void,
    ) void {
        const Context = @TypeOf(context);
        const Helper = struct {
            pub fn callback(typ: ErrorType, message: [*:0]const u8, userdata: ?*anyopaque) callconv(.C) void {
                callback(typ, message, if (Context == void) {} else @ptrCast(Context, @alignCast(@alignOf(Context), userdata)));
            }
        };
        Impl.deviceSetUncapturedErrorCallback(device, Helper.callback, if (Context == void) null else context);
    }

    pub inline fn tick(device: *Device) void {
        Impl.deviceTick(device);
    }

    pub inline fn reference(device: *Device) void {
        Impl.deviceReference(device);
    }

    pub inline fn release(device: *Device) void {
        Impl.deviceRelease(device);
    }
};
