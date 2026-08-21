import Sound
import lean_certs.cert_46_174

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_174_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 46) (d := 174) (c := cert_46_174) (by decide)
