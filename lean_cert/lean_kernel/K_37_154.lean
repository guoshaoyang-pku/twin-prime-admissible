import Sound
import lean_certs.cert_37_154

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_154_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 154 := by
  exact certValidRoot_sound (k := 37) (d := 154) (c := cert_37_154) (by decide)
