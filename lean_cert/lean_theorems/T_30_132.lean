import Sound
import lean_certs.cert_30_132

open CertVerify

theorem H30_gt_132 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 132 := by
  exact certValidRoot_sound (k := 30) (d := 132) (c := cert_30_132) (by native_decide)
