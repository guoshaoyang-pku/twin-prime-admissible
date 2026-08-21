import Sound
import lean_certs.cert_18_50

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H18_gt_50_kernel : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 50 := by
  exact certValidRoot_sound (k := 18) (d := 50) (c := cert_18_50) (by decide)
