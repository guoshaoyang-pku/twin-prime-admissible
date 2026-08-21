import Sound
import lean_certs.cert_13_34

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H13_gt_34_kernel : ¬ ∃ t : List Nat, admissible 13 t = true ∧ diameter t ≤ 34 := by
  exact certValidRoot_sound (k := 13) (d := 34) (c := cert_13_34) (by decide)
