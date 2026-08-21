import Sound
import lean_certs.cert_32_106

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H32_gt_106_kernel : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 106 := by
  exact certValidRoot_sound (k := 32) (d := 106) (c := cert_32_106) (by decide)
