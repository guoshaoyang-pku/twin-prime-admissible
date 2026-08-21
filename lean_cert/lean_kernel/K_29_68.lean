import Sound
import lean_certs.cert_29_68

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H29_gt_68_kernel : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 29) (d := 68) (c := cert_29_68) (by decide)
