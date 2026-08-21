import Sound
import lean_certs.cert_45_176

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_176_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 45) (d := 176) (c := cert_45_176) (by decide)
