import Sound
import lean_certs.cert_41_176

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H41_gt_176_kernel : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 41) (d := 176) (c := cert_41_176) (by decide)
