import Sound
import lean_certs.cert_30_96

open CertVerify

theorem H30_gt_96 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 30) (d := 96) (c := cert_30_96) (by native_decide)
