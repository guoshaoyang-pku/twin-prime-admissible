import Sound
import lean_certs.cert_24_68

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H24_gt_68_kernel : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 24) (d := 68) (c := cert_24_68) (by decide)
