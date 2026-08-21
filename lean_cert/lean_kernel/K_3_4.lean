import Sound
import lean_certs.cert_3_4

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H3_gt_4_kernel : ¬ ∃ t : List Nat, admissible 3 t = true ∧ diameter t ≤ 4 := by
  exact certValidRoot_sound (k := 3) (d := 4) (c := cert_3_4) (by decide)
