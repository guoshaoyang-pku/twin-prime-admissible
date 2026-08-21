import Sound
import lean_certs.cert_46_196

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_196_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 196 := by
  exact certValidRoot_sound (k := 46) (d := 196) (c := cert_46_196) (by decide)
