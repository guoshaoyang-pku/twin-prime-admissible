import Sound
import lean_certs.cert_41_116

open CertVerify

theorem H41_gt_116 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 41) (d := 116) (c := cert_41_116) (by native_decide)
