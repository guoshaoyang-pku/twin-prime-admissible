import Sound
import lean_certs.cert_40_174

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H40_gt_174_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 40) (d := 174) (c := cert_40_174) (by decide)
