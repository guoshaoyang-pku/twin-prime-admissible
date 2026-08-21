import Sound
import lean_certs.cert_44_174

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_174_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 44) (d := 174) (c := cert_44_174) (by decide)
