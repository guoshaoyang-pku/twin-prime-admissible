import Sound
import lean_certs.cert_27_86

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H27_gt_86_kernel : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 27) (d := 86) (c := cert_27_86) (by decide)
