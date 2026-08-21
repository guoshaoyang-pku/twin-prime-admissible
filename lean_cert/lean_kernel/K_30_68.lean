import Sound
import lean_certs.cert_30_68

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_68_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 30) (d := 68) (c := cert_30_68) (by decide)
