import Sound
import lean_certs.cert_25_68

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H25_gt_68_kernel : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 25) (d := 68) (c := cert_25_68) (by decide)
