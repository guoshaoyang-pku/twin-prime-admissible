import Sound
import lean_certs.cert_46_208

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H46_gt_208_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 208 := by
  exact certValidRoot_sound (k := 46) (d := 208) (c := cert_46_208) (by decide)
