import Sound
import lean_certs.cert_46_206

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H46_gt_206_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 206 := by
  exact certValidRoot_sound (k := 46) (d := 206) (c := cert_46_206) (by decide)
