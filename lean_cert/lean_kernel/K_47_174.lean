import Sound
import lean_certs.cert_47_174

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_174_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 174 := by
  exact certValidRoot_sound (k := 47) (d := 174) (c := cert_47_174) (by decide)
