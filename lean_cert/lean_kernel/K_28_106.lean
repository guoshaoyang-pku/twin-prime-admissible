import Sound
import lean_certs.cert_28_106

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H28_gt_106_kernel : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 28) (d := 106) (c := cert_28_106) (by decide)
