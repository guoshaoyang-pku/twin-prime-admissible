import Sound
import lean_certs.cert_41_80

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_80_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 41) (d := 80) (c := cert_41_80) (by decide)
