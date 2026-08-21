import Sound
import lean_certs.cert_50_196

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_196_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 196 := by
  exact certValidRoot_sound (k := 50) (d := 196) (c := cert_50_196) (by decide)
