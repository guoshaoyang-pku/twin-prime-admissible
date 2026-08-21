import Sound
import lean_certs.cert_47_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_98_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 47) (d := 98) (c := cert_47_98) (by decide)
