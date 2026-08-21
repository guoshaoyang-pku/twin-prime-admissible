import Sound
import lean_certs.cert_6_10

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H6_gt_10_kernel : ¬ ∃ t : List Nat, admissible 6 t = true ∧ diameter t ≤ 10 := by
  exact certValidRoot_sound (k := 6) (d := 10) (c := cert_6_10) (by decide)
