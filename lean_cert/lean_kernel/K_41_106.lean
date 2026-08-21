import Sound
import lean_certs.cert_41_106

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_106_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 41) (d := 106) (c := cert_41_106) (by decide)
