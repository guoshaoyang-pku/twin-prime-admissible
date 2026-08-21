import Sound
import lean_certs.cert_4_6

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H4_gt_6_kernel : ¬ ∃ t : List Nat, admissible 4 t = true ∧ diameter t ≤ 6 := by
  exact certValidRoot_sound (k := 4) (d := 6) (c := cert_4_6) (by decide)
