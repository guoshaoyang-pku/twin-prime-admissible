import Sound
import lean_certs.cert_40_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_124_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 40) (d := 124) (c := cert_40_124) (by decide)
