import Sound
import lean_certs.cert_48_106

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_106_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 48) (d := 106) (c := cert_48_106) (by decide)
