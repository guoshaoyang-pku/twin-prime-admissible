import Sound
import lean_certs.cert_38_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_124_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 38) (d := 124) (c := cert_38_124) (by decide)
