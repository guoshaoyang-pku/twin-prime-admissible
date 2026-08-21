import Sound
import lean_certs.cert_47_106

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_106_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 47) (d := 106) (c := cert_47_106) (by decide)
