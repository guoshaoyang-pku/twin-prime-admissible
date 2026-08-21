import Sound
import lean_certs.cert_50_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_124_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 50) (d := 124) (c := cert_50_124) (by decide)
