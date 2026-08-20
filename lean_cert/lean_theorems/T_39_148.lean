import Sound
import lean_certs.cert_39_148

open CertVerify

theorem H39_gt_148 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 148 := by
  exact certValidRoot_sound (k := 39) (d := 148) (c := cert_39_148) (by native_decide)
