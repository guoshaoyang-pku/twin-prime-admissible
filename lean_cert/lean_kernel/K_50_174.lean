import Sound
import lean_certs.cert_50_174

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_174_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 50) (d := 174) (c := cert_50_174) (by decide)
