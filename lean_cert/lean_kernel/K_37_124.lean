import Sound
import lean_certs.cert_37_124

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_124_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 124 := by
  exact certValidRoot_sound (k := 37) (d := 124) (c := cert_37_124) (by decide)
