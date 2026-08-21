import Sound
import lean_certs.cert_19_68

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H19_gt_68_kernel : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 19) (d := 68) (c := cert_19_68) (by decide)
