import Sound
import lean_certs.cert_30_106

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_106_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 30) (d := 106) (c := cert_30_106) (by decide)
