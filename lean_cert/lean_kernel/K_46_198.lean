import Sound
import lean_certs.cert_46_198

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_198_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 198 := by
  exact certValidRoot_sound (k := 46) (d := 198) (c := cert_46_198) (by decide)
