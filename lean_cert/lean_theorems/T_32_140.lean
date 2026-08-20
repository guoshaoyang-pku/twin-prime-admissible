import Sound
import lean_certs.cert_32_140

open CertVerify

theorem H32_gt_140 : ¬ ∃ t : List Nat, admissible 32 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 32) (d := 140) (c := cert_32_140) (by native_decide)
