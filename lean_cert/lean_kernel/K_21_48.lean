import Sound
import lean_certs.cert_21_48

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_48_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 21) (d := 48) (c := cert_21_48) (by decide)
