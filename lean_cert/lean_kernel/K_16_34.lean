import Sound
import lean_certs.cert_16_34

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H16_gt_34_kernel : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 34 := by
  exact certValidRoot_sound (k := 16) (d := 34) (c := cert_16_34) (by decide)
