import Sound
import lean_certs.cert_30_118

open CertVerify

theorem H30_gt_118 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 30) (d := 118) (c := cert_30_118) (by native_decide)
