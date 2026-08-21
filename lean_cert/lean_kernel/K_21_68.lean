import Sound
import lean_certs.cert_21_68

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H21_gt_68_kernel : ¬ ∃ t : List Nat, admissible 21 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 21) (d := 68) (c := cert_21_68) (by decide)
