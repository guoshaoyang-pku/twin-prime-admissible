import Sound
import lean_certs.cert_34_98

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H34_gt_98_kernel : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 34) (d := 98) (c := cert_34_98) (by decide)
