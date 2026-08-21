import Sound
import lean_certs.cert_45_174

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_174_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 45) (d := 174) (c := cert_45_174) (by decide)
