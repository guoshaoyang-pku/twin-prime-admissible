import Sound
import lean_certs.cert_44_154

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_154_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 44) (d := 154) (c := cert_44_154) (by decide)
