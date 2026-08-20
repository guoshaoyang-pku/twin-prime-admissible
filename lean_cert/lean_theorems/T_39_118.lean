import Sound
import lean_certs.cert_39_118

open CertVerify

theorem H39_gt_118 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 39) (d := 118) (c := cert_39_118) (by native_decide)
