import Sound
import lean_certs.cert_37_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H37_gt_142_kernel : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 37) (d := 142) (c := cert_37_142) (by decide)
