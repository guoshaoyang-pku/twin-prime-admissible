import Sound
import lean_certs.cert_47_142

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_142_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 142 := by
  exact certValidRoot_sound (k := 47) (d := 142) (c := cert_47_142) (by decide)
