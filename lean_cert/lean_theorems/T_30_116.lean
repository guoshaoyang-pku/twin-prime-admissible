import Sound
import lean_certs.cert_30_116

open CertVerify

theorem H30_gt_116 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 30) (d := 116) (c := cert_30_116) (by native_decide)
