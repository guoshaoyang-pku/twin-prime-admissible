import Sound
import lean_certs.cert_42_174

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H42_gt_174_kernel : ¬ ∃ t : List Nat, admissible 42 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 42) (d := 174) (c := cert_42_174) (by decide)
